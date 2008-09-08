From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 11506] oops during unmount - ext3? (2.6.27-rc5)
Date: Mon, 8 Sep 2008 18:02:24 +0200
Message-ID: <20080908160224.GA31029@atrey.karlin.mff.cuni.cz>
References: <20080904191356.GA7799@joi> <20080907112740.GA5530@joi> <20080907114714.GB5530@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47637 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYIHQC0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2008 12:02:26 -0400
Content-Disposition: inline
In-Reply-To: <20080907114714.GB5530@joi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sun, Sep 07, 2008 at 01:27:40PM +0200, Marcin Slusarz wrote:
> > Code: 8b 06 a8 01 75 04 0f 0b eb fe f6 c4 08 0f 84 2f 03 00 00 48 8b 45 b8 48 8b 40 10 c7 45 c8 01 00 00 00 48 89 45 d0 48 89 c3 31 c0 <8b> 53 20 01 c2 89 c0 48 39 45 b0 89 55 cc 48 9b 53 08 48 89 55
> Little correction (at the end):
>   Code: 8b 06 a8 01 75 04 0f 0b eb fe f6 c4 08 0f 84 2f 03 00 00 48 8b 45 b8 48 8b 40 10 c7 45 c8 01 00 00 00 48 89 45 d0 48 89 c3 31 c0 <8b> 53 20 01 c2 89 c0 48 39 45 b0 89 55 cc 48 8b 53 08 48 89 55
> 
> > Output of decodecode:
> After correction:
> /tmp/tmp.W6DvY3Lbtg.o:     file format elf64-x86-64
> 
> Disassembly of section .text:
> 
> 0000000000000000 <.text>:
>    0:   8b 06                   mov    (%rsi),%eax
>    2:   a8 01                   test   $0x1,%al
>    4:   75 04                   jne    0xa
>    6:   0f 0b                   ud2a
>    8:   eb fe                   jmp    0x8
>    a:   f6 c4 08                test   $0x8,%ah
>    d:   0f 84 2f 03 00 00       je     0x342
>   13:   48 8b 45 b8             mov    -0x48(%rbp),%rax
>   17:   48 8b 40 10             mov    0x10(%rax),%rax
>   1b:   c7 45 c8 01 00 00 00    movl   $0x1,-0x38(%rbp)
>   22:   48 89 45 d0             mov    %rax,-0x30(%rbp)
>   26:   48 89 c3                mov    %rax,%rbx
>   29:   31 c0                   xor    %eax,%eax
> 
> /tmp/tmp.W6DvY3Lbtg.o:     file format elf64-x86-64
> 
> Disassembly of section .text:
> 
> 0000000000000000 <.text>:
>    0:   8b 53 20                mov    0x20(%rbx),%edx
>    3:   01 c2                   add    %eax,%edx
>    5:   89 c0                   mov    %eax,%eax
>    7:   48 39 45 b0             cmp    %rax,-0x50(%rbp)
>    b:   89 55 cc                mov    %edx,-0x34(%rbp)
>    e:   48 8b 53 08             mov    0x8(%rbx),%rdx
>   12:   48                      rex.W
>   13:   89                      .byte 0x89
>   14:   55                      push   %rbp
  Hmm, from this disassembly it seems that somebody has overwritten our
page->private pointer to 1000c20d02020000 and then we obviously failed
to get bh->b_size. But I don't really see how this can happen. What also
puzzles me a bit is that I don't see BUG_ON(!PagePrivate(page)) in the
disassembly but it should be there because of page_buffers()
implementation... Anyone has an idea?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
