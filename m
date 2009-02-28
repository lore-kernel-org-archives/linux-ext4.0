From: David Fries <david@fries.net>
Subject: Re: [PATCH] Reorder ext4 and ext2 so that ext2 root filesystems
	are mounted using ext2
Date: Sat, 28 Feb 2009 08:39:43 -0600
Message-ID: <20090228143943.GD4894@spacedout.fries.net>
References: <1235831060-10086-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754164AbZB1OkW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1235831060-10086-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 28, 2009 at 09:24:20AM -0500, Theodore Ts'o wrote:
> It's doubtful that there are that many ext2-only root filesystem users
> that would also have ext4 compiled into the kernel, but to adhere to
> the principle of least surprise, the correct ordering in fs/Makefile
> is ext3, followed by ext2, and finally ext4.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> -obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4
> +obj-$(CONFIG_EXT2_FS)		+= ext2/
> +# We place ext4 after ext2 so plain ext2 root fs's are mounted using ext4
> +# unless explicitly requested by rootfstype
> +obj-$(CONFIG_EXT4_FS)		+= ext4/

Try
> +# We place ext4 after ext2 so plain ext2 root fs's aren't mounted using ext4
> +# unless explicitly requested by rootfstype

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
