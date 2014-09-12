From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal
 journal
Date: Fri, 12 Sep 2014 15:06:23 -0400
Message-ID: <BAY179-W471384B15AB594C29D96F9FDCD0@phx.gbl>
References: <BAY406-EAS308E30D9E82235BD5A84A0EFDCD0@phx.gbl>,<20140912164342.GA10178@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc4s5.hotmail.com ([65.54.190.207]:65060 "EHLO
	BAY004-OMC4S5.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaILTGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 15:06:25 -0400
In-Reply-To: <20140912164342.GA10178@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the change from journal_inode to journal_dev is/was made prior to th=
e recent change, the s_jnl_blocks will have whatever it last had. =A0So=
 if it started with journal_inode and then switched to journal_dev (aga=
in, prior to your fix) or no journal, the s_jnl_blocks will have the ol=
d journal_inode info, and adding/removing journal_dev does no clear it =
out. =A0For a new fs with created only with journal_dev, there is no is=
sue. =A0I'm just arguing that *adding* journal_dev should also zero thi=
s out.

+Reardon


----------------------------------------
> Date: Fri, 12 Sep 2014 09:43:42 -0700
> From: darrick.wong@oracle.com
> To: thomas_reardon@hotmail.com
> CC: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing inte=
rnal journal
>
> [cc linux-ext4]
>
> On Fri, Sep 12, 2014 at 10:09:55AM -0400, TR Reardon wrote:
>> Note that this only works (zeroes out) when removing inode journal. =
Removing
>> an existing journal_dev leaves s_jnl_blocks untouched. To be absolut=
ely
>> clean, perhaps it should be wiped in all removal cases?
>
> s_jnl_blocks shouldn't be set if an external journal is in use.
>
> (Unless it is somehow?)
>
> --D

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
