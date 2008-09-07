From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [Bug 11506] oops during unmount - ext3? (2.6.27-rc5)
Date: Sun, 7 Sep 2008 13:47:20 +0200
Message-ID: <20080907114714.GB5530@joi>
References: <20080904191356.GA7799@joi> <20080907112740.GA5530@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:62802 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYIGLrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 07:47:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1149725fgg.17
        for <linux-ext4@vger.kernel.org>; Sun, 07 Sep 2008 04:47:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080907112740.GA5530@joi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2008 at 01:27:40PM +0200, Marcin Slusarz wrote:
> Code: 8b 06 a8 01 75 04 0f 0b eb fe f6 c4 08 0f 84 2f 03 00 00 48 8b 45 b8 48 8b 40 10 c7 45 c8 01 00 00 00 48 89 45 d0 48 89 c3 31 c0 <8b> 53 20 01 c2 89 c0 48 39 45 b0 89 55 cc 48 9b 53 08 48 89 55
Little correction (at the end):
  Code: 8b 06 a8 01 75 04 0f 0b eb fe f6 c4 08 0f 84 2f 03 00 00 48 8b 45 b8 48 8b 40 10 c7 45 c8 01 00 00 00 48 89 45 d0 48 89 c3 31 c0 <8b> 53 20 01 c2 89 c0 48 39 45 b0 89 55 cc 48 8b 53 08 48 89 55

> Output of decodecode:
After correction:
/tmp/tmp.W6DvY3Lbtg.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   8b 06                   mov    (%rsi),%eax
   2:   a8 01                   test   $0x1,%al
   4:   75 04                   jne    0xa
   6:   0f 0b                   ud2a
   8:   eb fe                   jmp    0x8
   a:   f6 c4 08                test   $0x8,%ah
   d:   0f 84 2f 03 00 00       je     0x342
  13:   48 8b 45 b8             mov    -0x48(%rbp),%rax
  17:   48 8b 40 10             mov    0x10(%rax),%rax
  1b:   c7 45 c8 01 00 00 00    movl   $0x1,-0x38(%rbp)
  22:   48 89 45 d0             mov    %rax,-0x30(%rbp)
  26:   48 89 c3                mov    %rax,%rbx
  29:   31 c0                   xor    %eax,%eax

/tmp/tmp.W6DvY3Lbtg.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   8b 53 20                mov    0x20(%rbx),%edx
   3:   01 c2                   add    %eax,%edx
   5:   89 c0                   mov    %eax,%eax
   7:   48 39 45 b0             cmp    %rax,-0x50(%rbp)
   b:   89 55 cc                mov    %edx,-0x34(%rbp)
   e:   48 8b 53 08             mov    0x8(%rbx),%rdx
  12:   48                      rex.W
  13:   89                      .byte 0x89
  14:   55                      push   %rbp
