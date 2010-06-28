From: Tao Ma <tao.ma@oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
Date: Tue, 29 Jun 2010 07:16:10 +0800
Message-ID: <4C292D3A.5000208@oracle.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<4C21D442.8080703@oracle.com>
	<4C22F316.3080009@oracle.com>	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>	<4C284419.3000905@oracle.com>
	<x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030201010505030509040900"
Cc: axboe@kernel.dk, linux-ext4@vger.kernel.org,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030201010505030509040900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeff Moyer wrote:
> Tao Ma <tao.ma@oracle.com> writes:
>
>   
>> btw, I also met with a NULL pointer deference in cfq_yield. I have
>> attached the null.log also. This seems to be related to the previous
>> deadlock and happens when I try to remount the same volume after
>> reboot and ocfs2 try to do some recovery.
>>     
>
> Since I can't reproduce your binary kernel even with your .config, could
> you send me the disassembly of the cfq_yield function from your vmlinux
> binary?
>   
no problem. I have attached it.
btw, if you have any debug patch, I am happy to run it to make the 
problem more clear to you.

Regards,
Tao

--------------030201010505030509040900
Content-Type: text/plain;
 name="cfq_yield.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cfq_yield.txt"

ffffffff821614d8 <cfq_yield>:
ffffffff821614d8:	41 56                	push   %r14
ffffffff821614da:	41 55                	push   %r13
ffffffff821614dc:	49 89 fd             	mov    %rdi,%r13
ffffffff821614df:	41 54                	push   %r12
ffffffff821614e1:	55                   	push   %rbp
ffffffff821614e2:	48 89 f5             	mov    %rsi,%rbp
ffffffff821614e5:	53                   	push   %rbx
ffffffff821614e6:	48 8b 47 18          	mov    0x18(%rdi),%rax
ffffffff821614ea:	4c 8b 60 08          	mov    0x8(%rax),%r12
ffffffff821614ee:	65 48 8b 04 25 40 b5 	mov    %gs:0xb540,%rax
ffffffff821614f5:	00 00 
ffffffff821614f7:	48 8b b0 00 06 00 00 	mov    0x600(%rax),%rsi
ffffffff821614fe:	4c 89 e7             	mov    %r12,%rdi
ffffffff82161501:	e8 90 eb ff ff       	callq  ffffffff82160096 <cfq_cic_lookup>
ffffffff82161506:	48 85 c0             	test   %rax,%rax
ffffffff82161509:	48 89 c3             	mov    %rax,%rbx
ffffffff8216150c:	0f 84 f2 00 00 00    	je     ffffffff82161604 <cfq_yield+0x12c>
ffffffff82161512:	48 8d bd a0 05 00 00 	lea    0x5a0(%rbp),%rdi
ffffffff82161519:	e8 ab ba 19 00       	callq  ffffffff822fcfc9 <_raw_spin_lock>
ffffffff8216151e:	48 8b b5 00 06 00 00 	mov    0x600(%rbp),%rsi
ffffffff82161525:	4c 89 e7             	mov    %r12,%rdi
ffffffff82161528:	e8 69 eb ff ff       	callq  ffffffff82160096 <cfq_cic_lookup>
ffffffff8216152d:	49 89 c6             	mov    %rax,%r14
ffffffff82161530:	48 8b 85 00 06 00 00 	mov    0x600(%rbp),%rax
ffffffff82161537:	f0 48 ff 00          	lock incq (%rax)
ffffffff8216153b:	fe 85 a0 05 00 00    	incb   0x5a0(%rbp)
ffffffff82161541:	4d 85 f6             	test   %r14,%r14
ffffffff82161544:	0f 84 a6 00 00 00    	je     ffffffff821615f0 <cfq_yield+0x118>
ffffffff8216154a:	49 8b bd 48 03 00 00 	mov    0x348(%r13),%rdi
ffffffff82161551:	e8 a0 ba 19 00       	callq  ffffffff822fcff6 <_raw_spin_lock_irq>
ffffffff82161556:	48 8b 5b 10          	mov    0x10(%rbx),%rbx
ffffffff8216155a:	48 85 db             	test   %rbx,%rbx
ffffffff8216155d:	0f 84 83 00 00 00    	je     ffffffff821615e6 <cfq_yield+0x10e>
ffffffff82161563:	49 39 9c 24 68 03 00 	cmp    %rbx,0x368(%r12)
ffffffff8216156a:	00 
ffffffff8216156b:	75 41                	jne    ffffffff821615ae <cfq_yield+0xd6>
ffffffff8216156d:	41 83 bc 24 54 02 00 	cmpl   $0x1,0x254(%r12)
ffffffff82161574:	00 01 
ffffffff82161576:	75 36                	jne    ffffffff821615ae <cfq_yield+0xd6>
ffffffff82161578:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
ffffffff8216157f:	8b 70 38             	mov    0x38(%rax),%esi
ffffffff82161582:	83 fe ff             	cmp    $0xffffffffffffffff,%esi
ffffffff82161585:	74 27                	je     ffffffff821615ae <cfq_yield+0xd6>
ffffffff82161587:	48 8b 48 30          	mov    0x30(%rax),%rcx
ffffffff8216158b:	48 85 c9             	test   %rcx,%rcx
ffffffff8216158e:	74 1e                	je     ffffffff821615ae <cfq_yield+0xd6>
ffffffff82161590:	48 63 05 4d f2 5d 00 	movslq 6156877(%rip),%rax        # ffffffff827407e4 <cfq_slice_idle>
ffffffff82161597:	48 8b 15 e2 42 63 00 	mov    6505186(%rip),%rdx        # ffffffff82795880 <jiffies>
ffffffff8216159e:	48 01 c8             	add    %rcx,%rax
ffffffff821615a1:	48 39 d0             	cmp    %rdx,%rax
ffffffff821615a4:	79 08                	jns    ffffffff821615ae <cfq_yield+0xd6>
ffffffff821615a6:	3b b3 c0 00 00 00    	cmp    0xc0(%rbx),%esi
ffffffff821615ac:	75 38                	jne    ffffffff821615e6 <cfq_yield+0x10e>
ffffffff821615ae:	49 8b 04 24          	mov    (%r12),%rax
ffffffff821615b2:	48 8b b8 80 04 00 00 	mov    0x480(%rax),%rdi
ffffffff821615b9:	48 85 ff             	test   %rdi,%rdi
ffffffff821615bc:	74 1a                	je     ffffffff821615d8 <cfq_yield+0x100>
ffffffff821615be:	8b 8d 68 02 00 00    	mov    0x268(%rbp),%ecx
ffffffff821615c4:	8b 93 c0 00 00 00    	mov    0xc0(%rbx),%edx
ffffffff821615ca:	48 c7 c6 1d 8c 55 82 	mov    $0xffffffff82558c1d,%rsi
ffffffff821615d1:	31 c0                	xor    %eax,%eax
ffffffff821615d3:	e8 a1 07 f2 ff       	callq  ffffffff82081d79 <__trace_note_message>
ffffffff821615d8:	81 4b 04 00 20 00 00 	orl    $0x2000,0x4(%rbx)
ffffffff821615df:	4c 89 b3 f0 00 00 00 	mov    %r14,0xf0(%rbx)
ffffffff821615e6:	49 8b 85 48 03 00 00 	mov    0x348(%r13),%rax
ffffffff821615ed:	fe 00                	incb   (%rax)
ffffffff821615ef:	fb                   	sti    
ffffffff821615f0:	5b                   	pop    %rbx
ffffffff821615f1:	48 8b bd 00 06 00 00 	mov    0x600(%rbp),%rdi
ffffffff821615f8:	5d                   	pop    %rbp
ffffffff821615f9:	41 5c                	pop    %r12
ffffffff821615fb:	41 5d                	pop    %r13
ffffffff821615fd:	41 5e                	pop    %r14
ffffffff821615ff:	e9 51 8b ff ff       	jmpq   ffffffff8215a155 <put_io_context>
ffffffff82161604:	5b                   	pop    %rbx
ffffffff82161605:	5d                   	pop    %rbp
ffffffff82161606:	41 5c                	pop    %r12
ffffffff82161608:	41 5d                	pop    %r13
ffffffff8216160a:	41 5e                	pop    %r14
ffffffff8216160c:	c3                   	retq   

--------------030201010505030509040900
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--------------030201010505030509040900--
