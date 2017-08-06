From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused mode parameter
Date: Sat, 5 Aug 2017 22:16:50 -0400
Message-ID: <20170806021650.zwst5hgohuurh6w4@thunk.org>
References: <20170720094037.9159-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170720094037.9159-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 20, 2017 at 02:40:37AM -0700, Tahsin Erdogan wrote:
> ext4_alloc_file_blocks() does not use its mode parameter. Remove it.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
