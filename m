From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2 v8] XFS TESTS: ENOSPC Punch Hole Test
Date: Mon, 18 Jul 2011 17:09:52 -0700
Message-ID: <4E24CB50.7020506@linux.vnet.ibm.com>
References: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com> <1311026953.2790.49.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: aelder@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1311026953.2790.49.camel@doink>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/18/2011 03:09 PM, Alex Elder wrote:
> On Sun, 2011-07-17 at 16:52 -0700, Allison Henderson wrote:
>> This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
>> This test will verify that a hole can be punched even when the disk is full.
>> Reserved blocks should be used to complete the operation when there is not blocks
>> to further fragment the file.
>>
>> Because punching a hole does not always require extra blocks, there needs to
>> be several iterations of punching holes, and then filling the file system to 100%
>> usage before it is forced to grow the tree in order to handle the fragmentation.
>> The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.
>
> I have reviewed both of your updated patches.  They
> both look good to me.  I'll give it another day or
> two for others to comment if they like, but unless
> someone suggests changes I'll commit this for you.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>

Alrighty then, sounds good to me.  Thanks Alex!

Allison Henderson
