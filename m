From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Date: Thu, 14 Mar 2013 14:02:10 -0400
Message-ID: <20130314180210.GA7784@thunk.org>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
 <20130314040835.GB11821@thunk.org>
 <20130314174216.GA2981@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Josh Triplett <josh@joshtriplett.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130314174216.GA2981@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 14, 2013 at 10:42:16AM -0700, Josh Triplett wrote:
> On Thu, Mar 14, 2013 at 12:08:35AM -0400, Theodore Ts'o wrote:
> > Huh.  This is very, very weird.  Is this a repeatable crash?
> 
> I could reliably replicate it for that particular session, but now that
> I've rebooted the host, no.

Well, I can tell you that from the stack trace, it looks like when the
file system was first being mounted, and the journal was being
replayed (which makes sense since you snapshotted a live file system),
when the journal inode was read in, it appeared to be corrupt.  While
trying to print an message declaring that the file system was corrupt
(via ext4_error()), we somehow dereferenced a NULL pointer.

I can't quite see how this could have happened; I can't understand how
the journal inode would have looked corrupt in the first place, and if
it was corrupt, how it could have triggered a NULL dereference.  So I
must be missing something....

						- Ted
