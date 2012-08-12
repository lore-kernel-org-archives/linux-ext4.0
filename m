From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.4->(3.5.1 || 3.6-rc1) => can no longer mount 60TB ext4 filesystem
Date: Sun, 12 Aug 2012 09:52:43 -0400
Message-ID: <CAO9zADzpVeeQqcm78GK-Y562ieS6i5wnan7roCCwm0KLY0vdUA@mail.gmail.com>
References: <005501cd77e7$d222d020$76687060$@lucidpixels.com>
	<5027B04D.3090703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	ap@solarrain.com
To: Daniel Mack <zonque@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61299 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2HLNwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2012 09:52:44 -0400
Received: by obbuo13 with SMTP id uo13so5348777obb.19
        for <linux-ext4@vger.kernel.org>; Sun, 12 Aug 2012 06:52:44 -0700 (PDT)
In-Reply-To: <5027B04D.3090703@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 12, 2012 at 9:31 AM, Daniel Mack <zonque@gmail.com> wrote:
> On 11.08.2012 19:36, Justin Piszcz wrote:
>> Hello,
>>
>> I upgrade to each new kernel release and with 3.5.1 (from 3.4) I can no
>> longer mount my 60TB ext4 volume.
>> If I boot back to 3.4, it works fine.
>>
>> Details here:
>> https://lkml.org/lkml/2012/8/10/205
>>
>> Anything I can do besides testing each 3.5-rcX to find where the regression
>> lies?
>
> I'm not at all familiar with ext4 internals, but as always, an wasy way
> is to bisect such a problem. Any change you can do that?
>
>   http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
>
>
> Daniel
>

Hi,

Thanks, will save this for the future-- would of done this but Eric
Sandeen found the offending patch, I reverted it and I can mount the
filesystem now.

The bad commit was 8aeb00ff85ad25453765dd339b408c0087db1527 (per sandeen)

Justin.
