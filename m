From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Sun, 13 May 2012 00:24:35 -0400
Message-ID: <20120513042435.GB31866@thunk.org>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
 <20120511034945.GA15892@mobil.systemanalysen.net>
 <4FAD2161.3090108@landley.net>
 <20120511164605.GC6467@thunk.org>
 <4FADB860.2000009@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FADB860.2000009@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 11, 2012 at 08:09:52PM -0500, Rob Landley wrote:
> However, 95% of this use case is already covered by FAT, considering
> that most of these people are going to want to interchange with windows
> and mac, neither of which are necessarily happy with an ext3 formatted
> USB stick. (Sadly, that's what I normally do.  My usb keychain is fat
> formatted, because otherwise I can't use it to give a PDF to the guy at
> kinko's to print out. I suspect this is why it hasn't previously come up
> much.)

The other reason why I suspect it hasn't come up often is that USB
sticks are so painfully slow that the file system really isn't a
bottleneck.

I would expct this might be different if you were using a removable
HDD (or even an SSD) with a USB 3.0 interface.  In that case you
really might want a bette file system than VFAT, especially if you are
interchanging with another Linux system with an incompatible uid/gid
namespace.  That's not nearly as common a use case, though.

	    	       	      	 	      - Ted
