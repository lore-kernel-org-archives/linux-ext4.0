From: Jan Kara <jack@suse.cz>
Subject: Re: =?utf-8?B?5Zue5aSN77yaZXh0NA==?= =?utf-8?Q?=2C?= quota,
 projectid:  limits without capablity
Date: Wed, 10 Jan 2018 12:59:26 +0100
Message-ID: <20180110115926.tk6bri37bdjhipc2@quack2.suse.cz>
References: <c18ff577-be92-40ea-93ae-4401ce2107da.yuanliang.wyl@alibaba-inc.com>
 <0dc571a8-e1b2-4247-9e9d-df02c0b0d7c6.yuanliang.wyl@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        "adilger.kernel" <adilger.kernel@dilger.ca>,
        pkuelelixi <pkuelelixi@gmail.com>, jack <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Yuanliang Wang <yuanliang.wyl@alibaba-inc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0dc571a8-e1b2-4247-9e9d-df02c0b0d7c6.yuanliang.wyl@alibaba-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Wang!

On Wed 10-01-18 19:01:03, Yuanliang Wang wrote:
> Thank you for your enthusiastic response
> 
> the reason is :
>                         1、I saw
> that ignore_hardlimit allows root to exceed the limit，so should projid
> be consistent ?

Generally, it should be consistent. ignore_hardlimit is a different thing -
you want root to be able to exceed storage space limit but you don't want
root to be able to make information inconsistent...

>                         2、
> In our scenario we will use hardlink to share data between container and host, and between containers
> 
>                                         +------------------+
>                                         |                       |
>                                         |                       |
> +-------------+                     |                       |
> |                 |                     |                       |
> |                 |                     |     container     |
> |                 +--------------> |                       |
> |                 |                     |     file A          |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     +------------------+
> |                 |
> |                 |
> |                 |                     +------------------+
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |    container      |
> | host file A +---------------> |                       |
> |                 |                     |    file A           |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     +------------------+
> |                 |
> |                 |                     +------------------+
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 +------------->  |     container     |
> |                 |                     |                       |
> |                 |                     |                       |
> |                 |                     |    file A            |
> |                 |                     |                       |
> +-------------+                     |                       |
>                                         |                       |
>                                         +------------------+

I see but then which project ID does the 'file A' have? Project ID used for
neither of the containers is logical... Maybe the file is accessible only
read-only in your setup and so you don't care much about quotas for that
particular files but still it may be confusing that the file is not
accounted to the quota of each particular container. That's the reason why
project ID consistence is enforced.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
