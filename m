From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 1/3] implement uid and gid mount options for ext2
Date: Thu, 02 Aug 2012 06:00:55 -0700
Message-ID: <87629130u0.fsf@xmission.com>
References: <1343908443-17369-1-git-send-email-ludwig.nussel@suse.de>
	<1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
	<20120802130642.46b12c59@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
	Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
	Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
	Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
	"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20120802130642.46b12c59@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Thu, 2 Aug 2012 13:06:42 +0100")
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> +uid=n[:m]			Make all files appear to belong to uid n.
>> +				Useful for e.g. removable media with fstab
>> +				options 'user,uid=useruid'. The optional second
>> +				uid m is actually written to the file system.
>
> So what happens if I insert a USB key containing a device node to the
> hard disk ? Why is this functionality useful in the current form ?
>
> (ie I think you need an actual rational security model first)

> Also why is this at the per fs level duplicating stuff each time rather
> than at the vfs level - this seems to be vfs level functionality.

Even more fun there is essentially a generic implementation in the user
namespaces.  What needs to be implemented to support this is support for
mounting in a non-default user namespace, and then all of the mapping
functionality is generic.  Which I presume will imply MS_NODEV.

Eric
