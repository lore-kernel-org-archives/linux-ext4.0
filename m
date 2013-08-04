From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix handling of nodelalloc parameter
Date: Sat, 3 Aug 2013 21:36:58 -0400
Message-ID: <20130804013658.GD19781@thunk.org>
References: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 02, 2013 at 02:03:46PM +0200, Piotr Sarna wrote:
> Commit 26092bf ("ext4: use a table-driven handler for mount options")
> introduced buggy handling of nodelalloc parameter in mount command.
> 
> After explicitly using delalloc or nodelalloc parameter in mount command,
> MOPT_EXPLICIT flag is set. After that, a test ensures that "data=journal"
> and "delalloc" parameters are not simultaneously activated.
> Unluckily, the mentioned test reports a bug in both situations:
> - "data=journal,delalloc"
> - "data=journal,nodelalloc"
> whereas the second one is perfectly legal and acceptable.
> 
> A simple solution to this problem is in setting EXPLICIT_DELALLOC flag
> properly. This patch ensures that EXPLICIT_DELALLOC flag is set only
> if "delalloc" parameter was used, and not set in case of "nodelalloc".

Thanks for this bug report and patch.  There is an even simpler way of
fixing this doesn't involve adding an additional check in the code,
though.  Just make the following change the table entry:

     {Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
-      MOPT_EXT4_ONLY | MOPT_CLEAR | MOPT_EXPLICIT},
+      MOPT_EXT4_ONLY | MOPT_CLEAR},

I'll send out a patch which does this...

					- Ted
