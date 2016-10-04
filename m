From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 18:50:55 +0200
Message-ID: <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
 <20161004084136.GD17515@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161004084136.GD17515@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 04.10.2016 10:41, Jan Kara wrote:

> The problem looks like memory corruption:
[...]

Huh, very interesting -- thanks for the walkthrough!

> Anyway, adding linux-mm to CC since this does not look ext4 related but
> rather mm related issue.
> 
> Bugs like these are always hard to catch, usually it's some flaky device
> driver, sometimes also flaky HW. You can try running kernel with various
> debug options enabled in a hope to catch the code corrupting memory
> earlier - e.g. CONFIG_DEBUG_PAGE_ALLOC sometimes catches something,
> CONFIG_SLAB_DEBUG can be useful as well. Another option is to get a
> crashdump when the oops happens (although that's going to be a pain to
> setup on such a small machine) and then look at which places point to
> the corrupted memory - sometimes you can find old structures pointing to
> the place and find the use-after-free issue or stuff like that...

Uhh, that sounds painful. So I'm following Ted's advice and building
myself a 4.8 as we speak.

If the problem is fixed, would it be of any help to trace the source by
going back to the 4.4.0 and reproduce with the debug symbols you
mentioned? I don't think a memdump would be difficult on the machine
(while it certainly has a small form factor, it's got a 1 TB hdd and 16
GB of RAM, so it's not really that small).

Cheers,
Johannes

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
