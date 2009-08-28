From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid is dangerous but that's secret
Date: Fri, 28 Aug 2009 17:23:56 +1000 (EST)
Message-ID: <6311905a247b1ec1f264f6417ed6d5d6.squirrel@neil.brown.name>
References: <20090824212518.GF29763@elf.ucw.cz>
    <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
    <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
    <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
    <827hwos98u.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Ric Wheeler" <rwheeler@redhat.com>, "Pavel Machek" <pavel@ucw.cz>,
	"Rob Landley" <rob@landley.net>, "Theodore Tso" <tytso@mit.edu>,
	"Goswin von Brederlow" <goswin-v-b@web.de>,
	"kernel list" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: "Florian Weimer" <fweimer@bfk.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <827hwos98u.fsf@mid.bfk.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, August 28, 2009 5:11 pm, Florian Weimer wrote:
> * Ric Wheeler:
>
>> You continue to ignore the technical facts that everyone (both MD and
>> ext3) people put in front of you.
>>
>> If you have a specific bug in MD code, please propose a patch.
>
> In RAID 1 mode, it should read both copies and error out on
> mismatch. 8-)

Despite your smiley:

  no it shouldn't, and no one is making any claims about raid1 being
  unsafe, only raid4/5/6.

NeilBrown

