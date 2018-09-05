From: cgxu519 <cgxu519@gmx.com>
Subject: Re: [Jfs-discussion] [PATCH v2 4/5] jfs: cache NULL when
 both default_acl and acl are NULL
Date: Wed, 5 Sep 2018 14:13:47 +0800
Message-ID: <c231d198-7a4e-63a0-0a7d-9211ab0abfe9@gmx.com>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-4-cgxu519@gmx.com>
 <0e37733e-9acd-cf82-62f7-420f0fa864eb@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, devel@lists.orangefs.org,
 linux-f2fs-devel@lists.sourceforge.net
To: Dave Kleikamp <dave.kleikamp@oracle.com>, jack@suse.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
 shaggy@kernel.org, hubcap@omnibond.com, martin@omnibond.com
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <0e37733e-9acd-cf82-62f7-420f0fa864eb@oracle.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org


On 09/04/2018 04:34 AM, Dave Kleikamp wrote:
> Are you pushing these as a series, or would you like this patch pushed
> through the jfs tree?
I'd hope maintainers pick individual patch to their tree.

Thanks,
Chengguang

>
> On 8/31/18 9:33 AM, Chengguang Xu wrote:
>> default_acl and acl of newly created inode will be initiated
>> as ACL_NOT_CACHED in vfs function inode_init_always() and later
>> will be updated by calling xxx_init_acl() in specific filesystems.
>> Howerver, when default_acl and acl are NULL then they keep the value
>> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
>> in this case.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
