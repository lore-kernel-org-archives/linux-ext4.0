From: Nick Dokos <ndokos@gmail.com>
Subject: Re: "block_dump, bd" in debugfs
Date: Thu, 27 Jun 2013 02:00:50 -0400
Message-ID: <87d2r83xf1.fsf@gmail.com>
References: <20130627030513.217820@gmx.com> <51CBB405.2080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37067 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3F0GFG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Jun 2013 02:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Us5KJ-0001Ws-KE
	for linux-ext4@vger.kernel.org; Thu, 27 Jun 2013 08:05:03 +0200
Received: from pool-108-7-96-134.bstnma.fios.verizon.net ([108.7.96.134])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 27 Jun 2013 08:05:03 +0200
Received: from ndokos by pool-108-7-96-134.bstnma.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 27 Jun 2013 08:05:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> On 6/26/13 11:05 PM, jon ernst wrote:
>  ...
>> Also at the beginning of each line. The output pattern is "0000,
>> 0020, 0040, 0060, 0100, 0120", where are numbers such as"0080,"?
>
> Identical lines are suppressed, similar to what hexdump does by
> default.  You might have had a "*" in between?
>

Offsets are octal, so there is no 0080: adding octal 020 to
octal 0060 gets you to octal 0100.

-- 
Nick

