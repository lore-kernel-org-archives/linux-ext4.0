From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 13:30:42 -0400
Message-ID: <20110607173042.GB30037@thunk.org>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
 <4DEE4333.9@redhat.com>
 <BANLkTik74BM_TZin7rSXDRo1YftBsT-yYw@mail.gmail.com>
 <4DEE5C73.806@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35582 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab1FGRa4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 13:30:56 -0400
Content-Disposition: inline
In-Reply-To: <4DEE5C73.806@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 07, 2011 at 10:14:27AM -0700, Sunil Mushran wrote:
> On 06/07/2011 09:46 AM, Amir G. wrote:
> >I understand the bitterness in btrfs community regarding ext4 snapshot
> >feature. You might say the same things about ext4 64bit feature.
> >I think it is not up to us to decide how it rolls. it's the users
> >and companies involved that dictate where the development happens.
> 
> Bitterness is not the issue. The issue is what happens when your
> _patron_ has had enough of the project and decides to stop funding.

Yep.  On the other hand, the question is that if you move too slowly,
the patron is just as likely to find another solution to his/her
business problems.  Sometimes perfect is the enemy of the good, and
the best technology is not necesssarily what carries the day.
Practical issues of what is available and what works "good enough" are
just as important, if not more so.

The philosophical questions have been discussed before in the "Worse
is Better" dialectic.  See: http://dreamsongs.com/WorseIsBetter.html

Or, this set of slides by the same author, "Models of Software
Acceptance: How Winners Win": http://dreamsongs.com/Files/AcceptanceModels.pdf

Back to solid ground --- I'm not going to insist on perfection, but at
the same time, the maintenance burden is something that has to be
acceptable, and there needs to be plan towards making it better.  If I
thought Amir was going to disappear the moment the snapshot patches
got accepted, there's no way I'd be accepting them.

        	      	      	     	    - Ted
