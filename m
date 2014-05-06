From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Tue, 6 May 2014 09:44:55 +0200
Message-ID: <20140506074455.GB29151@x2.net.home>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
 <20140505140401.GD22287@thunk.org>
 <20140505142808.GF22287@thunk.org>
 <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain>
 <20140505144423.GG22287@thunk.org>
 <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
 <20140505175049.GA29151@x2.net.home>
 <20140505183253.GL22287@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140505183253.GL22287@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 05, 2014 at 02:32:53PM -0400, Theodore Ts'o wrote:
> >  BTW, the current trend is to use GPT partition types to identify
> >  purpose of the partition filesystem (for example extra GUID for
> >  /home). It's FS independent solution and it allows use the right
> >  filesystems for the right mountpoints. It's very attractive for
> >  example for virtual images where you don't have to setup fstab and
> >  identify FS, but you still have (for example) /home on the right
> >  place.
> 
> But a partition only gets one GUUID and one partition type.  So are
> you saying that the GUUID partition type would be used to indicate the
> concept of "this is the file system for /home", *instead* of "this is
> an btrfs file system" or "this is an ext4 file system"?

 Yes, GPT partition has two UUIDs, 
 
   - UUID = an unique partition identifier
   - GUID = partition type identifier

 I talked about the type (GUID). Note that this concept is just
 another point of view how to mount partitions, I don't think it will
 be a mainstream solution for standard machines. Now it's supported by
 systemd. More details:

  http://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/
 

 For old good fstab you can use PARTUUID= to identify partitions and
 to bypass filesystem specific identifiers. In this case it's unique 
 partition identifier, no partition type.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
