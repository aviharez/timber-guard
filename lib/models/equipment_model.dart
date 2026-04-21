/// Represents the supported categories of heavy forestry equipment.
enum EquipmentType {
  fellerBuncher('Feller Buncher'),
  forwarder('Forwarder'),
  harvester('Harvester'),
  skidder('Skidder'),
  loader('Loader'),
  processor('Processor');

  final String displayName;
  const EquipmentType(this.displayName);
}