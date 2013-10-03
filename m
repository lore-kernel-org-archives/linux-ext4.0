From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] fs/ext4/namei.c: reducing contention on s_orphan_lock
 mmutex
Date: Thu, 03 Oct 2013 17:08:00 -0600
Message-ID: <524DF8D0.2080307@hp.com>
References: <1380728219-60784-1-git-send-email-tmac@hp.com> <1380728219-60784-2-git-send-email-tmac@hp.com> <139DD231-CA27-40C1-BBB5-B66B29640DC0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	aswin@hp.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <139DD231-CA27-40C1-BBB5-B66B29640DC0@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/03/2013 06:41 PM, Andreas Dilger wrote:

>> +	struct inode *next_inode;
> 
> Stack space in the kernel is not so abundant that all (or any?) of these
> should get their own local variable.
> 
>>
>> -	if (!EXT4_SB(sb)->s_journal)
> 
> Same here.
> 
> 
> Cheers, Andreas

Thanks Andreas for the comments.  On larger machines with processors with lots of register, with the compiler optimization I don't think it matters whether stack variables or repeated common expressions are used.  On smaller machines with processors with limited number of registers, this will be a problem.  I'll fix these on my rework.

Thanks,
Mak.
