From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove warning message from ext4_issue_discard
 helper
Date: Mon, 20 Dec 2010 08:06:27 -0500
Message-ID: <20101220130627.GI23626@thunk.org>
References: <1290537723-18558-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290537723-18558-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 23, 2010 at 07:42:03PM +0100, Lukas Czerner wrote:
> ext4_issue_discard is supposed to be helper for calling discard, however
> in case that underlying device does not support discard it prints out
> the warning message and clears the DISCARD t_mount_opt flag. Since it
> can be (and is) used by others, it should not do anything and let the
> caller to handle the error case.
> 
> This commit removes warning message and flag setting from
> ext4_issue_discard and use it just in place where it is really needed
> (release_blocks_on_commit). FITRIM ioctl should not set any flags nor it
> should print out warning messages, so get rid of the warning as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Added to the ext4 patch queue, thanks for the ping.

      	     	  	       	      	      - Ted
