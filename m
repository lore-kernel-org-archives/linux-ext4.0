From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 07 Sep 2011 12:10:07 -0500
Message-ID: <4E67A56F.8040403@redhat.com>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com> <20110907064006.GA16042@infradead.org> <CAGpXXZL=+K0ETvM0kGE6zqe3pB7AS_exU+dCbpm+uUSG2JJ+0A@mail.gmail.com> <20110907165017.GA19151@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110907165017.GA19151@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/7/11 11:50 AM, Christoph Hellwig wrote:
> On Wed, Sep 07, 2011 at 12:45:34PM -0400, Greg Freemyer wrote:
>>> Can you add this testcase to xfstests?
>>
>> Christoph,
>>
>> Isn't that just a matter of extending test 068 to ext4
> 
> If you have recent enough xfsprogs that allow the freeze command
> for foreign filesystems that might work. 

where "recent enough" is since Tue Feb 10 14:41:51 2009 -0600

I say go for it :)

Could always add a quick helper to make sure the xfs_io command
doesn't fail on freeze, and _notrun if it does.

-Eric

