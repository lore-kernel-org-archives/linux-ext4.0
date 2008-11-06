From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 11:38:46 -0500
Message-ID: <20081106163846.GA1381@infradead.org>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Peter Staubach <staubach@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49131601.50407@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 06, 2008 at 11:06:25AM -0500, Peter Staubach wrote:
>> Index: kvm/fs/ext4/super.c
>> ===================================================================
>> --- kvm.orig/fs/ext4/super.c
>> +++ kvm/fs/ext4/super.c
>> @@ -1455,7 +1455,7 @@ static int ext4_fill_flex_info(struct su
>>   	/* We allocate both existing and potentially added groups */
>>  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
>> -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
>> +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<
>>   
>
> I suspect that you want to do the le16_to_cpu() and _then_
> add the 1.  Otherwise, adding 1 to a different byte order
> value won't do quite what is expected or hoped for...

Yes.  And if someone ran sparse over the code both the initial error
and this varaint would be trivial to spot..

