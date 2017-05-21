From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: keep existing extra fields when inode expands
Date: Sat, 20 May 2017 23:07:35 -0400
Message-ID: <20170521030735.774rzn2ti2axtzxi@thunk.org>
References: <149517801870.34533.16399602916806300461.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149517801870.34533.16399602916806300461.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 19, 2017 at 10:13:39AM +0300, Konstantin Khlebnikov wrote:
> ext4_expand_extra_isize() should clear only space between old and new size.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Thanks, applied.

					- Ted
