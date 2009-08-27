From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Thu, 27 Aug 2009 18:00:58 -0400
Message-ID: <4A97021A.7030902@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <200908271551.43840.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <200908271551.43840.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/27/2009 04:51 PM, Rob Landley wrote:
> On Thursday 27 August 2009 06:43:49 Ric Wheeler wrote:
>    
>> On 08/26/2009 11:53 PM, Rob Landley wrote:
>>      
>>> On Tuesday 25 August 2009 18:40:50 Ric Wheeler wrote:
>>>        
>>>> Repeat experiment until you get up to something like google scale or the
>>>> other papers on failures in national labs in the US and then we can have
>>>> an informed discussion.
>>>>          
>>> On google scale anvil lightning can fry your machine out of a clear sky.
>>>
>>> However, there are still a few non-enterprise users out there, and
>>> knowing that specific usage patterns don't behave like they expect might
>>> be useful to them.
>>>        
>> You are missing the broader point of both papers.
>>      
> No, I'm dismissing the papers (some of which I read when they first came out
> and got slashdotted) as irrelevant to the topic at hand.
>    

I guess I have to dismiss your dismissing then.
> Pavel has two failure modes which he can trivially reproduce.  The USB stick
> one is reproducible on a laptop by jostling said stick.  I myself used to have
> a literal USB keychain, and the weight of keys dangling from it pulled it out
> of the USB socket fairly easily if I wasn't careful.  At the time nobody had
> told me a journaling filesystem was not a reasonable safeguard here.
>
> Presumably the degraded raid one can be reproduced under an emulator, with no
> hardware directly involved at all, so talking about hardware failure rates
> ignores the fact that he's actually discussing a _software_ problem.  It may
> happen in _response_ to hardware failures, but the damage he's attempting to
> document happens entirely in software.
>
> These failure modes can cause data loss which journaling can't help, but which
> journaling might (or might not) conceivably hide so you don't immediately
> notice it.  They share a common underlying assumption that the storage
> device's update granularity is less than or equal to the filesystem's block
> size, which is not actually true of all modern storage devices.  The fact he's
> only _found_ two instances where this assumption bites doesn't mean there
> aren't more waiting to be found, especially as more new storage media types
> get introduced.
>
> Pavel's response was to attempt to document this.  Not that journaling is
> _bad_, but that it doesn't protect against this class of problem.
>
> Your response is to talk about google clusters, cloud storage, and cite
> academic papers of statistical hardware failure rates.  As I understand the
> discussion, that's not actually the issue Pavel's talking about, merely one
> potential trigger for it.
>
> Rob
>    


