From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Date: Tue, 16 Nov 2010 12:47:20 -0800
Message-ID: <AANLkTikz07C_=aZudup7xSpLnrEYi5No4QhL5WD9xxTx@mail.gmail.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
 <1289840723-3056-5-git-send-email-josef@redhat.com> <4CE2783F.1020004@redhat.com>
 <20101116125016.GA31957@dhcp231-156.rdu.redhat.com> <4CE28211.6060204@redhat.com>
 <20101116160545.GA2524@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Avi Kivity <avi@redhat.com>, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
	ocfs2-devel@oss.oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36308 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0KPUrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Nov 2010 15:47:42 -0500
In-Reply-To: <20101116160545.GA2524@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 8:05 AM, Josef Bacik <josef@redhat.com> wrote:
> On Tue, Nov 16, 2010 at 03:07:29PM +0200, Avi Kivity wrote:
>> On 11/16/2010 02:50 PM, Josef Bacik wrote:
>>> On Tue, Nov 16, 2010 at 02:25:35PM +0200, Avi Kivity wrote:
>>> > =A0On 11/15/2010 07:05 PM, Josef Bacik wrote:
>>> >> =A0Ext4 doesn't have the ability to punch holes yet, so make sur=
e we return
>>> >> =A0EOPNOTSUPP if we try to use hole punching through fallocate. =
=A0This support can
>>> >> =A0be added later. =A0Thanks,
>>> >>
>>> >
>>> > =A0Instead of teaching filesystems to fail if they don't support =
the
>>> > =A0capability, why don't supporting filesystems say so, allowing =
the fail
>>> > =A0code to be in common code?
>>> >
>>>
>>> There is no simple way to test if a filesystem supports hole punchi=
ng or not so
>>> the check has to be done per fs. =A0Thanks,
>>
>> Could put a flag word in superblock_operations. =A0Filesystems which
>> support punching (or other features) can enable it there.
>>
>> Or even have its own callback.
>>
>
> Sure but then you have to do the same thing for every other flag you =
add to
> fallocate and then you have this huge mess of random flags just so yo=
u don't
> call into the filesystem. =A0This way is a lesser of two evils I thin=
k. =A0Thanks,
>
> Josef

I'm not a true kernel hacker, so my opinion is not critical but I find
it hard to read / expand as

> +     /* We only support the FALLOC_FL_KEEP_SIZE mode */
> +     if (mode && (mode !=3D FALLOC_FL_KEEP_SIZE))
> +             return -EOPNOTSUPP;

How about:

#define EXT4_FALLOC_MODES_SUPPORTED (FALLOC_FL_KEEP_SIZE)

if (modes & ~EXT4_FALLOC_MODES_SUPPORTED)
             return -EOPNOTSUPP;


Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
