From: "kaefert@gmail.com" <kaefert@gmail.com>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Sun, 11 Nov 2012 19:14:40 +0100
Message-ID: <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40842 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2KKSPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 13:15:01 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2108618eaa.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Nov 2012 10:15:00 -0800 (PST)
In-Reply-To: <20121109000156.GQ19977@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/11/9 Theodore Ts'o <tytso@mit.edu>:
> On Wed, Nov 07, 2012 at 09:23:22AM +0100, kaefert@gmail.com wrote:
>
> Can you please run e2fsck from the command line, and capture the
> output (i.e., using "script").  I really need the e2fsck output to
> understand what is going on.  The strace output is really not helpful=
=2E
>
> In general, you may be better off simply not trusting gparted to run
> e2fsck and resize2fs for you.  If there are no problems I'm sure it's
> fine, but it's really hard to debug things if you insist on letting
> gparted swallon all of the useful debugging output....
>
>                                             - Ted

Hi there!

So it took several days, but after running it manually it finished to
run after a few days. However, It doesn't seem to get the filesystem
in a truely clean state, although it doesn't print an error (at least
not at the end), because I've ran e2fsck again on the same partition
and it found errors again. Here's the output of the last run that
completed:


kaefert@blechmobil:~$ sudo e2fsck -f -y -v /dev/sdb1
e2fsck 1.42.4 (12-Jun-2012)
Durchgang 1: Pr=FCfe Inodes, Blocks, und Gr=F6=DFen

Doppelter Blocks gefunden... starte Scan nach doppelten Block.
Durchgang 1B: Suche nach doppelten/defekten Blocks
Mehrfach beansprucht Block(s) in Inode 86114492: 4538368 4405248
<< ... removed millions of entries of the same pattern here ... >>
11648685 11648686
Durchgang 1C: Pr=FCfe Verzeichnisse nach Inodes mit doppelten Blocks.
Durchgang 1D: Gleiche doppelte Blocks ab
(es gibt 6 Inodes, die doppelte/defekte Blocks enthalten.)

Datei /Recordings/.../MVI_8559.MOV (Inode #86114492,
Modifikationszeitpunkt Sat Mar 24 20:23:54 2012)
  hat Block Nr.413455 doppelte Block(s), gemeinsam genutzt mit 1 Datei(=
en):
    /Recordings/.../MVI_8563.MOV (Inode #86114496, mod time Sat Mar 24
20:23:54 2012)
multiply claimed block map? ja

clone_file_block: interner Fehler; dup_blk f=FCr 4538368 wurde nicht ge=
funden

clone_file_block: interner Fehler; dup_blk f=FCr 4538368 wurde nicht ge=
funden

Datei /Recordings/.../MVI_8563.MOV (Inode #86114496,
Modifikationszeitpunkt Sat Mar 24 20:23:54 2012)
  hat Block Nr.413455 doppelte Block(s), gemeinsam genutzt mit 1 Datei(=
en):
    /Recordings/.../MVI_8559.MOV (Inode #86114492, mod time Sat Mar 24
20:23:54 2012)
Duplizierte Blocks bereits neu zugeordnet bzw. geklont.

Datei /Recordings/.../MVI_8571.MOV (Inode #86114504,
Modifikationszeitpunkt Sat Mar 24 22:09:56 2012)
  hat Block Nr.244958 doppelte Block(s), gemeinsam genutzt mit 1 Datei(=
en):
    /Recordings/.../MVI_8575.MOV (Inode #86114508, mod time Sat Mar 24
22:09:56 2012)
multiply claimed block map? ja

clone_file_block: interner Fehler; dup_blk f=FCr 7999488 wurde nicht ge=
funden

clone_file_block: interner Fehler; dup_blk f=FCr 7999488 wurde nicht ge=
funden

Datei /Recordings/.../MVI_8575.MOV (Inode #86114508,
Modifikationszeitpunkt Sat Mar 24 22:09:56 2012)
  hat Block Nr.244958 doppelte Block(s), gemeinsam genutzt mit 1 Datei(=
en):
    /Recordings/.../MVI_8571.MOV (Inode #86114504, mod time Sat Mar 24
22:09:56 2012)
Duplizierte Blocks bereits neu zugeordnet bzw. geklont.

Datei /Recordings/.../MVI_3598.MOV (Inode #86376840,
Modifikationszeitpunkt Thu Aug 23 21:14:34 2012)
  hat Block Nr.45835 doppelte Block(s), gemeinsam genutzt mit 1 Datei(e=
n):
    /Recordings/.../SomeFile.psd (Inode #86376844, mod time Thu Aug 23
21:14:34 2012)
multiply claimed block map? ja

clone_file_block: interner Fehler; dup_blk f=FCr 345554931 wurde nicht =
gefunden

clone_file_block: interner Fehler; dup_blk f=FCr 345554931 wurde nicht =
gefunden

Datei /Recordings/.../SomeFile.psd (Inode #86376844,
Modifikationszeitpunkt Thu Aug 23 21:14:34 2012)
  hat Block Nr.45835 doppelte Block(s), gemeinsam genutzt mit 1 Datei(e=
n):
    /Recordings/.../MVI_3598.MOV (Inode #86376840, mod time Thu Aug 23
21:14:34 2012)
Duplizierte Blocks bereits neu zugeordnet bzw. geklont.

Durchgang 2: Pr=FCfe Verzeichnis Struktur
Durchgang 3: Pr=FCfe Verzeichnis Verkn=FCpfungen
Durchgang 4: =DCberpr=FCfe die Referenzz=E4hler
Durchgang 5: =DCberpr=FCfe Gruppe Zusammenfassung

/dev/sdb1: ***** DATEISYSTEM WURDE VER=C4NDERT *****

121950 Inodes sind in Benutzung (0.07%)
    1244 nicht zusammenh=E4ngende Dateien (1.0%)
      30 nicht zusammenh=E4ngende Verzeichnisse (0.0%)
         # von Inodes mit ind/dind/tind Bl=F6cken: 0/0/0
         Erweiterungstiefe Histogramm: 121816/126
184589222 Bl=F6cke werden benutzt (25.20%)
0 ung=FCltige Bl=F6cke
       4 gro=DFe Dateien

  119827 regul=E4re Dateien
    2114 Verzeichnisse
       0 zeichenorientierte Ger=E4tedateien
       0 Blockger=E4tedateien
       0 Fifos
      11 Verkn=FCpfungen
       0 symbolische Verkn=FCpfungen (0 schnelle symbolische Verkn=FCpf=
ungen)
       0 Sockets
--------
  121952 Dateien



The part that takes that extremly long (like days) is "Durchgang 1D:
Gleiche doppelte Blocks ab"  =3D "Pass 1D: Reconciling multiply-claimed
blocks"
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
