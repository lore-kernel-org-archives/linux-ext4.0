From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH]: e2fsprogs m_* self tests no longer pass
Date: Tue, 22 Mar 2011 17:16:38 +0100
Message-ID: <6898685A-0ADF-4AF1-8823-E4663A32983D@whamcloud.com>
References: <AANLkTikX2u+tz7e39tb8abRuXtiLDusKpjAf9vZ1tYUU@mail.gmail.com> <alpine.LFD.2.00.1103011046240.3874@dhcp-27-109.brq.redhat.com> <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com> <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com> <20110319202929.GA9875@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Lukas Czerner <lczerner@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bruce Cassidy <bruce@whamcloud.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50359 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab1CVQQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 12:16:42 -0400
Received: by eyx24 with SMTP id 24so1869336eyx.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 09:16:41 -0700 (PDT)
In-Reply-To: <20110319202929.GA9875@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-19, at 9:29 PM, Ted Ts'o wrote:
> On Tue, Mar 15, 2011 at 01:50:48PM -0600, Andreas Dilger wrote:
>> Only display the "Discarding device blocks:" status bar if discard
>> is actually implemented in the IO manager and in the kernel.
>> Otherwise, there is no correct test result that will work in all
>> environments.  I'd prefer not to print an error message for the
>> majority of devices that do not support discard, since this is
>> confusing.
> 
> I believe this should be fixed already by commit aa07cb79b0, which is
> in the e2fsprogs master and next branches.  Can you confirm?

It looks like it will do the same thing, though I don't know what the semantics are for doing a 0-length discard.  I'm reluctant to do an operation like this that may not have well-defined semantics (e.g. return EINVAL for this case).

My patch only does the requested discard, and checks the return of the first call.  It still makes sense to print an error for anything other than EXT2_ET_UNIMPLEMENTED instead of silently hiding the error.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



