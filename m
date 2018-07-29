From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: use swap macro in mext_page_double_lock
Date: Sun, 29 Jul 2018 16:12:36 -0400
Message-ID: <20180729201236.GF21725@thunk.org>
References: <20180726174323.GA28731@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180726174323.GA28731@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 26, 2018 at 12:43:23PM -0500, Gustavo A. R. Silva wrote:
> Make use of the swap macro and remove unnecessary variable *tmp*.
> This makes the code easier to read and maintain.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks, applied.

					- Ted
