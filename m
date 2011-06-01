From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36262] ext3 umount: BUG: unable to handle kernel paging request
Date: Wed, 1 Jun 2011 05:57:10 GMT
Message-ID: <201106010557.p515vAiw016102@demeter2.kernel.org>
References: <bug-36262-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60972 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1FAF5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 01:57:11 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p515vAxI016103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 05:57:10 GMT
In-Reply-To: <bug-36262-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36262





--- Comment #2 from Roger Luethi <rl@hellgate.ch>  2011-06-01 05:57:06 ---
Dump of assembler code for function __percpu_counter_add:
   0xc0391638 <+0>:     push   %ebp
   0xc0391639 <+1>:     mov    %esp,%ebp
   0xc039163b <+3>:     push   %edi
   0xc039163c <+4>:     mov    %eax,%edi
   0xc039163e <+6>:     push   %esi
   0xc039163f <+7>:     mov    $0x1,%eax
   0xc0391644 <+12>:    push   %ebx
   0xc0391645 <+13>:    sub    $0x14,%esp
   0xc0391648 <+16>:    mov    %edx,-0x18(%ebp)
   0xc039164b <+19>:    mov    %ecx,-0x1c(%ebp)
   0xc039164e <+22>:    call   0xc05bdf1d <add_preempt_count>
   0xc0391653 <+27>:    mov    0x30(%edi),%eax
   0xc0391656 <+30>:    mov    -0x18(%ebp),%edx
   0xc0391659 <+33>:    mov    %eax,-0x20(%ebp)
   0xc039165c <+36>:    mov    -0x1c(%ebp),%ecx
   0xc039165f <+39>:    mov    %fs:(%eax),%ebx
   0xc0391662 <+42>:    mov    0x8(%ebp),%eax
   0xc0391665 <+45>:    mov    %ebx,%esi
   0xc0391667 <+47>:    mov    %eax,-0x14(%ebp)
   0xc039166a <+50>:    sar    $0x1f,%esi
   0xc039166d <+53>:    add    %edx,%ebx
   0xc039166f <+55>:    adc    %ecx,%esi
   0xc0391671 <+57>:    cltd   
   0xc0391672 <+58>:    mov    %edx,-0x10(%ebp)
   0xc0391675 <+61>:    cmp    %edx,%esi
   0xc0391677 <+63>:    jl     0xc0391686 <__percpu_counter_add+78>
   0xc0391679 <+65>:    jg     0xc039167f <__percpu_counter_add+71>
   0xc039167b <+67>:    cmp    %eax,%ebx
   0xc039167d <+69>:    jb     0xc0391686 <__percpu_counter_add+78>
   0xc039167f <+71>:    mov    $0x1,%edx
   0xc0391684 <+76>:    jmp    0xc03916a9 <__percpu_counter_add+113>
   0xc0391686 <+78>:    mov    0x8(%ebp),%edx
   0xc0391689 <+81>:    neg    %edx
   0xc039168b <+83>:    mov    %edx,%ecx
   0xc039168d <+85>:    mov    %edx,-0x14(%ebp)
   0xc0391690 <+88>:    sar    $0x1f,%ecx
   0xc0391693 <+91>:    mov    $0x1,%edx
   0xc0391698 <+96>:    mov    %ecx,-0x10(%ebp)
   0xc039169b <+99>:    cmp    -0x10(%ebp),%esi
   0xc039169e <+102>:   jl     0xc03916a9 <__percpu_counter_add+113>
   0xc03916a0 <+104>:   jg     0xc03916a7 <__percpu_counter_add+111>
   0xc03916a2 <+106>:   cmp    -0x14(%ebp),%ebx
   0xc03916a5 <+109>:   jbe    0xc03916a9 <__percpu_counter_add+113>
   0xc03916a7 <+111>:   xor    %edx,%edx
   0xc03916a9 <+113>:   mov    -0x3f65dc64(,%edx,4),%ecx
   0xc03916b0 <+120>:   inc    %ecx
   0xc03916b1 <+121>:   test   %edx,%edx
   0xc03916b3 <+123>:   mov    %ecx,-0x3f65dc64(,%edx,4)
   0xc03916ba <+130>:   je     0xc03916dc <__percpu_counter_add+164>
   0xc03916bc <+132>:   mov    %edi,%eax
   0xc03916be <+134>:   call   0xc05b923a <_raw_spin_lock>
   0xc03916c3 <+139>:   add    %ebx,0x20(%edi)
   0xc03916c6 <+142>:   mov    0x30(%edi),%eax
   0xc03916c9 <+145>:   adc    %esi,0x24(%edi)
   0xc03916cc <+148>:   movl   $0x0,%fs:(%eax)
   0xc03916d3 <+155>:   mov    %edi,%eax
   0xc03916d5 <+157>:   call   0xc05b9ce5 <_raw_spin_unlock>
   0xc03916da <+162>:   jmp    0xc03916e2 <__percpu_counter_add+170>
   0xc03916dc <+164>:   mov    -0x20(%ebp),%eax
   0xc03916df <+167>:   mov    %ebx,%fs:(%eax)
   0xc03916e2 <+170>:   mov    $0x1,%eax
   0xc03916e7 <+175>:   call   0xc05bdd76 <sub_preempt_count>
   0xc03916ec <+180>:   xor    %ecx,%ecx
   0xc03916ee <+182>:   mov    %esp,%eax
   0xc03916f0 <+184>:   and    $0xffffe000,%eax
   0xc03916f5 <+189>:   mov    0x8(%eax),%ebx
   0xc03916f8 <+192>:   mov    $0xc08ee9a8,%eax
   0xc03916fd <+197>:   shr    $0x3,%ebx
   0xc0391700 <+200>:   and    $0x1,%ebx
   0xc0391703 <+203>:   mov    %ebx,%edx
   0xc0391705 <+205>:   call   0xc01e513f <ftrace_likely_update>
   0xc039170a <+210>:   mov    -0x3f65dc78(,%ebx,4),%eax
   0xc0391711 <+217>:   inc    %eax
   0xc0391712 <+218>:   test   %ebx,%ebx
   0xc0391714 <+220>:   mov    %eax,-0x3f65dc78(,%ebx,4)
   0xc039171b <+227>:   je     0xc0391722 <__percpu_counter_add+234>
   0xc039171d <+229>:   call   0xc05b6228 <preempt_schedule>
   0xc0391722 <+234>:   add    $0x14,%esp
   0xc0391725 <+237>:   pop    %ebx
   0xc0391726 <+238>:   pop    %esi
   0xc0391727 <+239>:   pop    %edi
   0xc0391728 <+240>:   leave  
   0xc0391729 <+241>:   ret    
End of assembler dump.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
