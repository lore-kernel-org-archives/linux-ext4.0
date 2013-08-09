From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: improve mount/remount error handling
Date: Thu, 8 Aug 2013 23:03:50 -0400
Message-ID: <20130809030350.GB1186@thunk.org>
References: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
 <1375445027-25024-2-git-send-email-p.sarna@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375445027-25024-2-git-send-email-p.sarna@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 02, 2013 at 02:03:47PM +0200, Piotr Sarna wrote:
> Commit 5688978 ("ext4: improve handling of conflicting mount options")
> introduced incorrect messages shown while choosing wrong mount options.
> 
> Firstly, both cases of incorrect mount options, "data=journal,delalloc"
> and "data=journal,dioread_nolock" result in the same error message.
> 
> Secondly, the problem above isn't solved for remount option: the mismatched
> parameter is simply ignored. Moreover, ext4_msg states that remount
> with options "data=journal,delalloc" succeeded, which is not true.
> 
> To fix it up, I added a simple check after parse_options() call to ensure
> that data=journal and delalloc/dioread_nolock parameters are not present
> at the same time.
> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied, thanks.

						- Ted
