From: Ted Ts'o <tytso@thunk.org>
Subject: Re: [PATCH 1/3] ext4: Remove kernel_lock annotations
Date: Mon, 7 Nov 2011 10:53:26 -0500
Message-ID: <20111107155326.GC24234@thunk.org>
References: <1320654148-4394-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1320654148-4394-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 07, 2011 at 09:22:28AM +0100, Richard Weinberger wrote:
> The BKL is gone, these annotations are useless.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks, applied to the ext4 tree.

				- Ted
