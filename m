From: Vasily Averin <vvs@sw.ru>
Subject: Re: [RFC PATCH ext3/ext4] orphan list corruption due bad inode
Date: Tue, 05 Jun 2007 10:11:12 +0400
Message-ID: <4664FE80.4080801@sw.ru>
References: <4663A0CE.102@sw.ru> <20070604190340.dba85bb0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org, linux-ext4@vger.kernel.org,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:18585 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbXFEGLj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 02:11:39 -0400
In-Reply-To: <20070604190340.dba85bb0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Mon, 04 Jun 2007 09:19:10 +0400 Vasily Averin <vvs@sw.ru> wrote:
>> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
>> index 9bb046d..e3ac8c3 100644
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -1019,6 +1019,11 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
>>  
>>  		if (!inode)
>>  			return ERR_PTR(-EACCES);
>> +
>> +		if (is_bad_inode(inode)) {
>> +			iput(inode);
>> +			return ERR_PTR(-ENOENT);	
>> +		}
>>  	}
>>  	return d_splice_alias(inode, dentry);
>>  }
> Seems reasonable.  So this prevents the bad inodes from getting onto the
> orphan list in the first place?

make_bad_inode() is called from ext3_read_inode() that is called from iget() only.

When we found that inode is bad we will call iput ASAP. I expect it should be
enough to exclude any chances to call any functions that can include this inode
into orphan list.

ext3_lookup
  iget
    ext3_read_inode
       make_bad_inode
  is_bad_inode? --> iput

However am I probably err?

Probably is better to add is_bad_inode check to ext3_orphan_add()?

thank you,
	Vasily Averin
