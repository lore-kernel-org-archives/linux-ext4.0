From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] fs/ext4/namei.c: reducing contention on s_orphan_lock
 mmutex
Date: Thu, 03 Oct 2013 02:31:51 -0600
Message-ID: <524D2B77.7090006@hp.com>
References: <1380728219-60784-1-git-send-email-tmac@hp.com> <1380728219-60784-2-git-send-email-tmac@hp.com> <20131003020526.GA22501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: T Makphaibulchoke <tmac@hp.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, aswin@hp.com, aswin_proj@lists.hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131003020526.GA22501@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/02/2013 08:05 PM, Zheng Liu wrote:
> Hello,
> 

>> -	if (!EXT4_SB(sb)->s_journal)
>> +	if (ext4_sb->s_journal)
>         ^^^^^^^^
>         typo: !ext4_sb->s_journal
> I am not sure whether or not this will impact the result because when
> journal is enabled the inode will not be added into orphan list.
> 
> Regards,
>                                                 - Zheng
> 
Thanks Zheng for pointing out the problem.  Will fix the problem and rerun the test.

Thanks,
Mak.
