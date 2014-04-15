From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Tue, 15 Apr 2014 10:27:46 -0600
Message-ID: <534D5E02.6030500@hp.com>
References: <1380728283-61038-1-git-send-email-tmac@hp.com> <1396456148-20455-1-git-send-email-tmac@hp.com> <20140402174109.GD8657@quack.suse.cz> <534C135A.9010803@hp.com> <20140414174024.GC13860@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, aswin@hp.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140414174024.GC13860@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/14/2014 11:40 AM, Jan Kara wrote:
>   Thanks for trying that out! Can you please send me a patch you have been
> testing? Because it doesn't quite make sense to me why using i_mutex should
> be worse than using hashed locks...
>

Thanks again for the comments.

Since i_mutex is also used for serialization in other operations on an inode, in the case that the i_mutex is not held  using it for serialization could cause contention with other operations on the inode.  As the number shows substantial instances of orphan add or delete calls without holding the i_mutex, I presume the performance degradation is due to the contention.

As for the patch, could you please let me know if you need the patch using i_mutex or the patch I'm planning to submit.  If it's the latter, I'm thinking of go ahead and resubmit it.

Thanks,
Mak.

>   OK, at least that makes sense.
> 
> 								Honza
> 
