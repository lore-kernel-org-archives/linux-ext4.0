From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 2/2] ext4: make use of sb_getblk_gfp
Date: Thu, 02 Jul 2015 09:16:34 +0300
Message-ID: <5594D742.6040202@kyup.com>
References: <1435645609-20387-1-git-send-email-kernel@kyup.com> <1435645609-20387-2-git-send-email-kernel@kyup.com> <20150702061427.GB3108@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150702061427.GB3108@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/02/2015 09:14 AM, Theodore Ts'o wrote:
> On Tue, Jun 30, 2015 at 09:26:49AM +0300, Nikolay Borisov wrote:
>> Switch ext4 to using sb_getblk_gfp with GFP_NOFS added, this fixes
>> possible deadlocks in the page writeback path.
>>
>> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
> 
> I've added this to the ext4.git tree, thanks.
> 
> 						- Ted

Thanks!

Just a question that popped to my mind after discussing with a colleague
- Is GFP_NOFS enough here or should it be GFP_NOIO? Presumably the
latter is a stronger guarantee that we are not going to hit any
fs/writeback related code?

Nikolay
