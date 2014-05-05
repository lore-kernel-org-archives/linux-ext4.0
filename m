From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 14:32:53 -0400
Message-ID: <20140505183253.GL22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
 <20140505140401.GD22287@thunk.org>
 <20140505142808.GF22287@thunk.org>
 <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain>
 <20140505144423.GG22287@thunk.org>
 <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
 <20140505175049.GA29151@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140505175049.GA29151@x2.net.home>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 05, 2014 at 07:50:49PM +0200, Karel Zak wrote:
>    1) audit / logging purpose
>    2) mount <device> --last-target
>    3) automount (for example udisks and removable media)
> 
>  unfortunately 2) and 3) seem fragile as the filesystem superblocks
>  have no clue about namespaces and the same filesystem is possible to
>  mount in the same time to more places, etc.

Yes, "location last mounted" is really only useful as a backup
mechanism.  I've never claimed that it would be guaranteed to be the
most useful thing in the presence of bind mounts, namespaces, being
mounted in multiple locations, etc.  *Usually,* the namespace the first
time the file system is mounted is more interesting than subsequent
mounts or bind mounts, but there really is no guarantee.

>  BTW, the current trend is to use GPT partition types to identify
>  purpose of the partition filesystem (for example extra GUID for
>  /home). It's FS independent solution and it allows use the right
>  filesystems for the right mountpoints. It's very attractive for
>  example for virtual images where you don't have to setup fstab and
>  identify FS, but you still have (for example) /home on the right
>  place.

But a partition only gets one GUUID and one partition type.  So are
you saying that the GUUID partition type would be used to indicate the
concept of "this is the file system for /home", *instead* of "this is
an btrfs file system" or "this is an ext4 file system"?

Or is this some kind of GPT extension that I'm not aware of?

      	   	     	    	      	   - Ted
