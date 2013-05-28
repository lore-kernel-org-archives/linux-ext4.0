From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: ext4: Printing debug is now configurable
Date: Tue, 28 May 2013 07:53:52 -0400
Message-ID: <20130528115352.GD11839@thunk.org>
References: <1367358660-940-1-git-send-email-taysom@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	olofj@chromium.org
To: Paul Taysom <taysom@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1367358660-940-1-git-send-email-taysom@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 30, 2013 at 02:51:00PM -0700, Paul Taysom wrote:
> Printing the "truncating inode" and "deleting unreferenced inode"
> messages is now controlled by the "debug" option to mount.
> These messages were filling the /var/log/messages file and
> are normal for ext4 file system recovery.
> 
> Tested by opening several files, unlinking them, then
> crashing the system, rebooting the system and examining
> /var/log/messages.
> 
> Addresses the problem described in http://crbug.com/220976
> 
> Signed-off-by: Paul Taysom <taysom@chromium.org>

Added to the ext4 patch queue with a slightly modified description.
(Sorry for the delay, you sent the patch just as the merge window had
starting, and I wasn't accepting new until the tree had settled down.)

	      	       		     - Ted
