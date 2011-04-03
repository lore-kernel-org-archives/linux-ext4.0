From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy an odd file
Date: Sun, 3 Apr 2011 06:46:09 -0400
Message-ID: <4F38B379-26DC-4E8D-AD8C-2C0E5D3D4E86@mit.edu>
References: <87fwq0gay0.fsf@rho.meyering.net> <4D9724AC.2070009@draigBrady.com> <8739m0g3u7.fsf@rho.meyering.net> <87d3l4edb1.fsf@rho.meyering.net> <20110402230005.GL21075@thunk.org> <4D9847F5.8030804@draigBrady.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jim Meyering <jim@meyering.net>, 8411@debbugs.gnu.org,
	linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:64351 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab1DCKqS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 06:46:18 -0400
In-Reply-To: <4D9847F5.8030804@draigBrady.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 3, 2011, at 6:12 AM, P=E1draig Brady wrote:

> So this fix is not in 2.6.38?
> It was committed before 2.6.38-rc6 was released,
> and I would have thought it appropriate for 2.6.38 :(
> Anyway I guess that we now have to assume that there
> can be 2.6.38 kernels in the wild with this issue,
> even if the stable branch does get the fix soon.


Yeah, the patch was complicated enough that I was concerned about pushi=
ng it that late in the 2.6.38 development cycle.   When I was told that=
 this feature was in a pre-release shellutils, I made the call not to t=
ry to rush things....  We can get it into a 2.6.38 stable release fairl=
y quickly.

-- Ted


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
