From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 21 May 2008 10:23:23 +0900
Message-ID: <1AE3C150C90A4C1A8C024C3D6079C948@nsl.ad.nec.co.jp>
References: <20080514170625t-sato@mail.jp.nec.com>
	<20080520035712.GA7252@webber.adilger.int>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080520035712.GA7252@webber.adilger.int>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

Andreas Dilger wrote:
>> +static int ioctl_freeze(struct file *filp)
>> +{
>> +    struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +    if (!capable(CAP_SYS_ADMIN))
>> +        return -EPERM;
>> +
>> +    /* If filesystem doesn't support freeze feature, return. */
>> +    if (sb->s_op->write_super_lockfs == NULL)
>> +        return -EINVAL;
> 
> Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
> something wrong with the passed ioctl parameters (e.g. bad value),
> while EOPNOTSUPP is "operation not supported" and makes more sense.

Sounds good.
I will send new patch-set which is rebased to 2.6.26-rc3 and includes
this fix, in this weekend.

Cheers, Takashi
