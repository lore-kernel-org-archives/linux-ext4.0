From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: use percpu counter for extent cache count
Date: Fri, 01 Mar 2013 12:02:34 -0600
Message-ID: <5130ED3A.30003@redhat.com>
References: <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com> <20130227192907.GB14253@thunk.org> <20130227201217.GD14253@thunk.org> <20130301033005.GA7081@redhat.com> <20130301040039.GA4452@thunk.org> <20130301050029.GB4452@thunk.org> <5130DA71.4040808@redhat.com> <20130301180035.GB17920@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Jones <davej@redhat.com>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CASCm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 13:02:42 -0500
In-Reply-To: <20130301180035.GB17920@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/1/13 12:00 PM, Theodore Ts'o wrote:
> On Fri, Mar 01, 2013 at 10:42:25AM -0600, Eric Sandeen wrote:
>> Use a percpu counter rather than atomic types for shrinker accounting.
>> There's no need for ultimate accuracy in the shrinker, so this
>> should come a little more cheaply.  The percpu struct is somewhat
>> large, but there was a big gap before the cache-aligned
>> s_es_lru_lock anyway, and it fits nicely in there.
> 
> I thought about using percpu counters, but I was worried about the
> size on really big machines.  OTOH, it will be the really large NUMA
> machines where atomic_t will really hurt, so maybe we should use
> percpu countesr and not really worry about it.  It's on a per file
> system basis, so even if it is a few hundred bytes it shouldn't break
> the bank.
> 
> 						- Ted
> 

I was mostly keying off what quota felt was best, I guess.
I'm not wedded to either approach, it was just a thought.
So you can take it or leave it. :)

Thanks,
-Eric
