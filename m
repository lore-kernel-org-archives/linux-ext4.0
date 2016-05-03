From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/6] statx: Make windows attributes available for CIFS, NTFS and FAT to use
Date: Tue, 03 May 2016 21:23:44 +0100
Message-ID: <10431.1462307024@warthog.procyon.org.uk>
References: <D21EA8F8-0A7A-4275-8D4C-E9CFCC2A7293@dilger.ca> <20160429125736.23636.47874.stgit@warthog.procyon.org.uk> <20160429125813.23636.49830.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D21EA8F8-0A7A-4275-8D4C-E9CFCC2A7293@dilger.ca>
Content-ID: <10430.1462307024.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> > 	__u32	st_win_attrs;
> 
> It seems some of these flags are duplicated with the st_information field,
> and some are duplicate with FS_IOC_GETFLAGS values, and returning the same
> information in multiple ways is confusing.
>
> If these flags are part of the CIFS protocol,

They're part of the Windows API.  CIFS/SMB and NTFS have them at the same
values.

> and are directly usable by Samba then I can understand we wouldn't want to
> change them once in the kernel and then convert them back in userspace, but
> I'm a bit reluctant to have flags only for CIFS/NTFS/FAT that might also be
> useful for other filesystems.

Where said "other filesystems" have some support for Windows or OS/2 and have
bits defined that map directly in semantics, if not in value, to these bits.

JFS, for example, has IREADONLY, IHIDDEN, ISYSTEM, IDIRECTORY, IARCHIVE and
ISPARSE.

> Would we want to be able to get translated
> st_win_attrs flags in ext4 attrs when it is being exported by Samba?

Actually, I was thinking of proposing an ext4 patch that stored windows flags
in a separate word in the inode on disk.  There isn't sufficient bit space to
map all the windows flags to FS_IOC_GETFLAGS.  However, as you say, there is a
certain amount of overlap...

David
