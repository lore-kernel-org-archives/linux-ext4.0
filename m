From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Wed, 6 Jun 2012 16:40:12 +0200
Message-ID: <1482118647.20120606164012@eikelenboom.it>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net> <1018371644.20120605224154@eikelenboom.it> <20120605210806.GB7182@thunk.org> <1883708187.20120606090126@eikelenboom.it> <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	<dm-devel@redhat.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:60741
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2FFOkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2012 10:40:20 -0400
In-Reply-To: <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Wednesday, June 6, 2012, 4:32:52 PM, you wrote:

> On Wed, Jun 6, 2012 at 12:01 AM, Sander Eikelenboom
> <linux@eikelenboom.it> wrote:
>> Another thing that thought of that could be of interest, i think this was a ext3 converted to ext4 partition.
>> Don't know if that is true for the other reports as well though.

> FWIW, in my case, I have just built a fresh ext4 and immediately copy
> data to it.

> -Kees



And it still results in the error ?
And if you use it without the uninit_bg feature by running:

tune2fs -O ^uninit_bg

Then fsck found errors in my case after fixing them, i could copy files normally.
Does that work in your case as well ?
--
Sander


