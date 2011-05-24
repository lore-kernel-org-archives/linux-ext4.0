From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 14/19] ext3: remove unnecessary dentry_unhash on
 rmdir/rename_dir
Date: Tue, 24 May 2011 16:57:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1105241603330.9500@cobra.newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
 <1306267582-5347-15-git-send-email-sage@newdream.net> <20110524203802.GA14304@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110524203802.GA14304@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 May 2011, Jan Kara wrote:
> On Tue 24-05-11 13:06:17, Sage Weil wrote:
> > ext3 has no problems with lingering references to unlinked directory
> > inodes.
>   OK, so if I understand right, dentry_unhash() has been there only so that
> filesystem can detect whether (something under) removed directory is in
> use? So filesystems which can happily handle unlinked but open directories
> don't need it, right? If that's the case, you can add:
>   Acked-by: Jan Kara <jack@suse.cz>
> to this patch and also the ext2 version.

Right.  Basically, a simple fs can return EBUSY if the dentry is hashed 
(implying there are still references) and not worry about a racing process 
traversing into the directory while rmdir is running.  A sane fs can 
handle references and doesn't care if a racing process traverses into the 
dir before the ->rmdir method completes.

Thanks!
sage
