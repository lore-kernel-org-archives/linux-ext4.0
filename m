From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Fri, 10 May 2013 13:38:57 -0700
Message-ID: <518D5AE1.7040905@gmail.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130510192747.GA11707@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/10/2013 12:27 PM, Theodore Ts'o wrote:
> Hmm, since you seem to be able to reproduce the problem reliably, any
> chance you can try bisecting the problem?  I've looked at the commits
> that touch fs/jbd2 and nothing is jumping out at me.
>
> Also, how many CPU's do you have your system, and what kind of storage
> device were you using when you were running iozone (5400rpm HDD,
> 7200RPM HDD, RAID array, SSD, etc.)?

I too have seen this.

My system is:

   12 CPU Octeon (MIPS64)
   Root is ext3, mounted via ext4fs on a slow CompactFlash/PIO6

I saw the crash when simply booting  a fairly bare-bones Debian distro, 
although it is somewhat random:
.
.
ata3: PATA max PIO6 cmd 900000001d040000 ctl 900000001d05000d irq 63
.
.
ata3.00: CFA: CF 4GB, 20101001, max UDMA/133
ata3.00: 7847280 sectors, multi 0: LBA
ata3.00: configured for PIO6
.
.
scsi 2:0:0:0: Direct-Access     ATA      CF 4GB           2010 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 7847280 512-byte logical blocks: (4.01 GB/3.74 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda2): mounting ext3 file system using the ext4 subsystem
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
.
.
.

I have not been able to get it to fail a second time.  So for me 
bisecting might not work.

David Daney


>
> Thanks,
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
