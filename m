From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT3 way too happy with write errors
Date: Fri, 02 Jan 2009 20:45:29 -0600
Message-ID: <495ED149.2080305@redhat.com>
References: <20081015002256.GD25662@hostway.ca> <20081218170714.GA6797@atrey.karlin.mff.cuni.cz> <20081218171825.GD20515@hostway.ca> <20081218172759.GE13580@duck.suse.cz> <20081218174921.GF20515@hostway.ca> <532480950812181029k1baf8264y82fb6d9760fe05f8@mail.gmail.com> <20090103021516.GE9995@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Mike Snitzer <snitzer@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Simon Kirby <sim@netnation.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbZACCps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jan 2009 21:45:48 -0500
In-Reply-To: <20090103021516.GE9995@hostway.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Simon Kirby wrote:
>> On Thu, Dec 18, 2008 at 9:49 AM, Simon Kirby <sim@netnation.com> wrote:
>>> Not aborting on data write error: User loses data.  File system gets very
>>> confused.

A *data* write error should not confuse the *filesystem* - it'll just be
a corrupt file (assuming it was just an EIO / write failure and not some
misdirected IO).

>>> What am I missing?
>> I can think of certain situations when companies may care about
>> getting most of the data to disk and clean it up later.
>> Datacenters may be replicating the data to many spindles and may
>> sometimes care about throughput as much as possible. So lossy data
>> could be preferred to complete data.
>>
>> Not saying this is always preferred but I can see a use case.
> 
> Ok, fine, in this case they might know what they are doing.  Still, this
> is not reason enough to default the case in point... ?
> 
> :)

So one thing I have not seen clearly stated:

When you got the initial write error that bothers you; was that for data
 or metadata?

For a metadata write it should certainly not be ignored (other than for
crazy people who run with errors=ignore) because this implies that the
filesystem is no longer consistent.

But for a data write error there is some grey area.  If your application
cares about data integrity then it'd be doing direct IO or syncing data
and checking for errors; if it's doing buffered writes and carrying on
blindly assuming that everything is sweetness and light, well, that's
the application's choice.  But assuming the entire filesystem should
implode on one file's data write failure is probably not the best plan.

FWIW, Part of the reason for the defaults as they are, IIRC, is to keep
the current/historical behavior, but with an option to be more strict
for those who wish it.  As you do.  :)

-Eric (coming off a long vacation and hoping he's remembering this all
correctly) :)
