From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: report delalloc reserve as non-free in statfs
 mangled by project quota
Date: Sun, 20 May 2018 22:52:33 -0400
Message-ID: <20180521025233.GH4464@thunk.org>
References: <151756800585.979296.13086151972011935611.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151756800585.979296.13086151972011935611.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 02, 2018 at 01:40:05PM +0300, Konstantin Khlebnikov wrote:
> This reserved space isn't committed yet but cannot be used for allocations.
> For userspace it has no difference from used space. XFS already does this.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 689c958cbe6b ("ext4: add project quota support")

Applied, thanks.  Apologies for the delay in applying the patch.

					- Ted
