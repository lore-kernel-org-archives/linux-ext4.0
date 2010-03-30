From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Tue, 30 Mar 2010 09:26:52 +0400
Message-ID: <8739zie5wj.fsf@openvz.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
	<20100326004738.GJ3145@quack.suse.cz>
	<20100326033824.GC21658@thunk.org>
	<20100326104205.GA3055@quack.suse.cz>
	<20100326133856.GE21658@thunk.org>
	<20100330005504.GJ5835@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:11402 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0C3F1E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Mar 2010 01:27:04 -0400
In-Reply-To: <20100330005504.GJ5835@quack.suse.cz> (Jan Kara's message of
	"Tue, 30 Mar 2010 02:55:05 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Fri 26-03-10 09:38:56, tytso@mit.edu wrote:
>> On Fri, Mar 26, 2010 at 11:42:05AM +0100, Jan Kara wrote:
>> > > There may also be other programs that depend on the existence of
>> > > aquota.user, and may be reading and writing them in various random
>> > > ways, and there is the question of how do we provide compatibility
>> > > with these other programs, some of which may not be within quotatools,
>> > > but in various magic virtualization or container or cluster management
>> > > systems....
>> >   Yeah, this is possible, although I'm not aware of any such program -
>> 
>> Actually, Google's cluster management system is accessing/modifying
>> aquota.group file directly before and after quota is enabled.  This
>> may change in the future, but it's one more point of compatibility.
>   I see. Thanks for info.
>
>> >   Yeah, I believe that support for the oldest quota format can be phased
>> > out - the new format is around for something like 10 years and it had
>> > it's problems at that time already. I guess I'll add a warning to the
>> > next release of quota-tools to the people still using it.
>> 
>> And if we transition to using quotactl calls to access and read the
>> information in the quota files, then the actual format of the quota
>> file won't matter any more, right?
>   Yes, hopefully.
>
>> Stupid question --- how does repquota work on OCFS2?  I don't see any
>> quotactl subcommands that would appear to return the functionality
>> needed by repquota --- unless you just assume that the only uid/gid's
>> in use are in /etc/passwd and /etc/group, and just call quotactl for
>> each uid/gid in the system passwd and group files.
>   Currently it does not work at all. I didn't get to writing it when
> writing original quota support for OCFS2 because the inferface won't be
> completely trivial and it would be complicated for OCFS2 to expose the
> file directly. Probably the interface will have to be something like
> readdir but then you have to have some "handles" and state associated
> with them and it gets complicated. Maybe we could make our life simpler
> by returning an read-only unseekable fd from repquota quotactl and reading
> from it would pass quota structures. But I haven't thought too much about
> it.
Ok. i hope finally we will end up with something like this.
Before introducing this interface it is reasonable to redesign
dquot structures itself because they aren't linked together
so it is not easy to iterate it without probing each id in a loop.
