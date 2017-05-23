From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 5/6] ubifs: Implement export_operations
Date: Tue, 23 May 2017 10:41:16 +0200
Message-ID: <04af5127-e8f3-a2e9-4d2f-af5ef9fc1531@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
 <1495398051-4604-6-git-send-email-richard@nod.at>
 <20170523083932.GC4107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170523083932.GC4107@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph,

Am 23.05.2017 um 10:39 schrieb Christoph Hellwig:
>> +static struct inode *ubifs_nfs_get_inode(struct super_block *sb, uint64_t ino,
>> +					 uint32_t generation)
>> +{
>> +	return ubifs_iget(sb, ino);
>> +}
> 
> You need to maintain and check an inode generation counter for this
> to be safe.

UBIFS has no inode generations, inodes simply can't wrap around.
We "handle" it like JFF2 does, we assumes that the NAND is long dead
before we reach the maximum inode number.

Thanks,
//richard
