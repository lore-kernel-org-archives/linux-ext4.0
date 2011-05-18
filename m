From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Wed, 18 May 2011 11:00:22 -0700
Message-ID: <20110518180022.GM18929@tux1.beaverton.ibm.com>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>, tytso@mit.edu,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305731882-8334-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 18, 2011 at 05:17:59PM +0200, Jan Kara wrote:
> 
>   Hi,
> 
>   this is a second version of my patches which rewrite ext4_page_mkwrite() to
> use generic helper. When we are already changing this code, I also added proper
> handling of frozen filesystem there in patch 2/3. I've incorporated suggestions
> from Christoph in the patches which resulted in some patch reorg. I'd like to
> get these patches reviewed and then get them merged possibly via ext4-tree
> (although the first two patches might go via Al but that would complicate
> merging of ext4 part where I expect more conflicts with ongoing work).

Do you want me to generate a patch to add wait_on_page_writeback to the
appropriate place(s) in your new *_page_mkwrite functions, or do you plan to
add them yourself?

(iow: is there an order for pushing these ext4_page_mkwrite changes?)

--D
