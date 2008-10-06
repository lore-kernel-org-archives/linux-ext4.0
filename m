From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Mon, 06 Oct 2008 12:50:31 -0300
Message-ID: <48EA33C7.80702@diamondcut.com.br>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754108AbYJFPuo@vger.kernel.org>
In-Reply-To: <48EA2F20.7020309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> Quentin Godfroy wrote:
>> For the two fs the only inode which shows up is the inode 8 (this
>> seems to be the journal. According to 'stat <8>' in debugfs it looks
>> like the journal is 134Megs long. I don't remember exactly how I
>> created the fs, but i'm sure I did not specified the journal
>> size. Does it seem reasonable for a 6,6G fs?
>
> 134 Megs sounds wrong.  What does dumpe2fs -h say?  I'm guessing you
> didn't calculate it quite correctly.

I'm running 2.6.26.2 (ext3) and dumpe2fs show me:
Journal size: 128M

# fdisk -l

Disk /dev/sda: 100.0 GB, 100030242816 bytes
255 heads, 63 sectors/track, 12161 cylinders
Units = cilindros of 16065 * 512 = 8225280 bytes
Disk identifier: 0xe5d80ea3

Dispositivo Boot      Start         End      Blocks   Id  System
/dev/sda1               1         889     7139328   27  Unknown
Partition 1 does not end on cylinder boundary.
/dev/sda2   *         889        4780    31250000    7  HPFS ou NTFS
Partition 2 does not end on cylinder boundary.
/dev/sda3            4781        7212    19527480   83  Linux
Partition 3 does not end on cylinder boundary.
/dev/sda4            7212       12161    39758040    5  Extended
Partition 4 does not end on cylinder boundary.
/dev/sda5            7212        7274      498928+  82  Linux swap
/dev/sda6            7274       12161    39259048+  83  Linux

Regards,
Renato
