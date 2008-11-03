From: "Martin Bligh" <mbligh@mbligh.org>
Subject: Re: The default assignee for the ext4 component goes nowhere
Date: Sun, 2 Nov 2008 23:01:47 -0800
Message-ID: <8f3aa8d60811022301tc784cc1saea84719aa20d7a4@mail.gmail.com>
References: <E1Kwkhw-0007O5-Mr@closure.thunk.org>
	 <20081102134803.28c12d8b.akpm@linux-foundation.org>
	 <20081102230806.GN8134@mit.edu>
	 <20081102193226.df026896.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, bugme-admin@linux-foundation.org,
	linux-ext4@vger.kernel.org, "Sami Liedes" <sliedes@cc.hut.fi>,
	"Francois Valenduc" <francois.valenduc@tvcablenet.be>
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:61366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYKCHBt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 02:01:49 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2079787fgg.17
        for <linux-ext4@vger.kernel.org>; Sun, 02 Nov 2008 23:01:47 -0800 (PST)
In-Reply-To: <20081102193226.df026896.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 2, 2008 at 7:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 2 Nov 2008 18:08:06 -0500 Theodore Tso <tytso@mit.edu> wrote:
>
>> On Sun, Nov 02, 2008 at 01:48:03PM -0800, Andrew Morton wrote:
>> >
>> > I think the normal way of doing this is to create an account at bugzilla
>> > called linux-ext4@vger.kernel.org then you can log in using that account
>> > and add it to various assignees using the "users to watch" feature.
>>
>> Ah, so the fs_ext4@kernel-bugs.osdl.org is really a bugzilla
>> pseudo-user?
>
> I guess so.

It is. That way we can have multiple people administer a category, etc.

>>   But for the ext3 component was set to assign bugs to you
>> by default, as opposed to creating a fs_ext3 pseudo-user?
>
> Ah.  We'll need to change that.  You don't want all my bugzilla traffic
> landing on linux-ext4 :)

You want me to create another pseudo user? is easy to do.

>> I'm just trying to figure out how the bugzilla system is supposed to
>> be working...
>
> I'm far from a definitive source on that matter.
>
> I'm not sure who's reading bugme-admin at present.

The planned way of doing things is basically to have a pseudo-user for
each category. Then anyone who is interested can just set up an email
watch on that psuedo user (go under "Prefs" then select email preferences
tab).

Some "legacy" ones are set up to still go directly to one user.

A (very) few people have requested mailing lists get cc'ed on some
categories, for which we've set up mailing list users, and had them
watch the categories too.
