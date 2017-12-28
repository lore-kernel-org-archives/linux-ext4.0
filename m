From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/12] ext2: drop unneeded newline
Date: Wed, 27 Dec 2017 23:30:42 -0500
Message-ID: <20171228043042.GB30269@thunk.org>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
 <1514386305-7402-5-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, kernel-janitors@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514386305-7402-5-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 27, 2017 at 03:51:37PM +0100, Julia Lawall wrote:
> ext2_msg prints a newline at the end of the message string, so the message
> string does not need to include a newline explicitly.  Done using
> Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

					- Ted
