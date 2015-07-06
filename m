From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4:Make the function ext4_ext_tree_init have a return
 type of void
Date: Sun, 5 Jul 2015 22:25:28 -0400
Message-ID: <20150706022528.GL8628@thunk.org>
References: <1436144944-25343-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436144944-25343-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 05, 2015 at 09:09:04PM -0400, Nicholas Krause wrote:
> This makes the function ext4_ext_tree_init have a return type of
> void due to this function always completed its intended work of
> intialzing a ext4_extent_header structue pointer off its passed
> arguments of a inode and handle_t pointer.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Nick,

You *promised* you would give up on sending cleanup patches.

Clearly, you can't be trusted.

						- Ted
