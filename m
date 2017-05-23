From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 4/6] ubifs: Maintain a parent pointer
Date: Tue, 23 May 2017 10:42:31 +0200
Message-ID: <99b3f295-be4e-14a1-a21d-e9055949a8ef@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
 <1495398051-4604-5-git-send-email-richard@nod.at>
 <20170523083758.GB4107@infradead.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170523083758.GB4107@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph,

Am 23.05.2017 um 10:37 schrieb Christoph Hellwig:
> On Sun, May 21, 2017 at 10:20:49PM +0200, Richard Weinberger wrote:
>> The new feature UBIFS_FLG_PARENTPOINTER allows looking
>> up the parent. Usually the Linux VFS walks down the filesystem
>> and no parent pointers are needed. But when a filesystem
>> is exportable via NFS such a lookup is needed.
>> We can use a padding field in struct ubifs_ino_node to
>> maintain a pointer to the parent inode.
> 
> Note that nfsd/exportfs will only do this for directories, and beacause
> we hardlinks for other objects that is an important distinction.
> 
> I think the ubifs code should make sure to only maintain the parent
> pointers for directories, otherwise confusion and abuses will happen.

Thanks for the info, I'll massage the code in that direction.

Thanks,
//richard
