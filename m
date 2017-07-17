From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: jbd2: transaction: Add kernel-doc parameter
 descriptions
Date: Mon, 17 Jul 2017 11:12:33 +0200
Message-ID: <20170717091233.GA18199@quack2.suse.cz>
References: <20170626045022.GA32222@sayli-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org
To: sayli karnik <karniksayli1995@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170626045022.GA32222@sayli-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 26-06-17 10:20:22, sayli karnik wrote:
> Add function parameters in kernel-doc comments to fix warnings in the
> Sphinx build:
> transaction.c:511: warning: No description found for parameter 'type'
> transaction.c:511: warning: No description found for parameter 'line_no'
> 
> Signed-off-by: sayli karnik <karniksayli1995@gmail.com>

I'd suggest to have more useful description like below:

> + * @type: type of handle

the reason why transaction handle was started - one of EXT4_TH_ defines

> + * @line_no: line number of handle

the line from which the function was called (used for debug output)

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
