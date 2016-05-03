From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info available
Date: Tue, 03 May 2016 16:53:02 +0100
Message-ID: <27119.1462290782@warthog.procyon.org.uk>
References: <E67F5D32-A06A-4C30-8DCB-EF20D86200D4@dilger.ca> <20160429125736.23636.47874.stgit@warthog.procyon.org.uk> <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E67F5D32-A06A-4C30-8DCB-EF20D86200D4@dilger.ca>
Content-ID: <27118.1462290782.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> > 	STATX_INFO_ENCRYPTED		File is encrypted
> 
> This flag overlaps with FS_ENCRYPT_FL that is encoded in the FS_IOC_GETFLAGS
> attributes.  Are the FS_* flags expected to be translated into STATX_INFO_*
> flags by each filesystem, or will they be partly duplicated in a separate
> "st_attrs" field added in the future?

I think that most of the FS_IOC_GETFLAGS flags are sufficiently specialised
that they aren't something the ordinary user would necessarily find to be of
interest, so I'm not sure that mapping all of them to STATX_INFO_* flags is
necessary.

That said, I think STATX_INFO_ENCRYPTED *is* usefully deployed here to tell
the user that the file or directory is encrypted and that the user will have
to unlock or provide a key to access it.

I'm also thinking that a STATX_INFO_NEED_AUTHENTICATION flag may be needed to
indicate that the user must authenticate in some way (probably only applicable
to network files) to be able to access the file.

David
